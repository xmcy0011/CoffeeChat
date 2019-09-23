/** @file redis.go
 * @brief redis再封装，统一增加前缀"cim|"，支持多个redis db等
 * @author CoffeeChat
 * @date 2019/9/19
 */

package db

import (
	"errors"
	"fmt"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"github.com/go-redis/redis"
	"time"
)

type RedisConnect struct {
	name string

	redisClient *redis.Client
}

type RedisPool struct {
	clientMap map[string]*RedisConnect
}

type RedisPoolConfig struct {
	Name       string // 名称
	DbNum      int    // 在redis中数据库的位置
	MaxConnect int    // 最大连接数
}

// 禁止更改，全局
var DefaultRedisPool = &RedisPool{}

// 统一key的前缀
var redisKeyPrefix = ""

const KUnreadKeyName = "unread"
const KMsgIdKeyName = "msgid"
const KOnlineKeyName = "online_user_hash"

func InitCache(ip string, port int, pwd string, keyPrefix string, pool []*RedisPoolConfig) error {
	address := fmt.Sprintf("%s:%d", ip, port)
	redisKeyPrefix = keyPrefix

	logger.Sugar.Info("init cache connection,redis address:", address)
	DefaultRedisPool.clientMap = make(map[string]*RedisConnect)

	for i := 0; i < len(pool); i++ {
		poolInfo := pool[i]

		conn := &RedisConnect{
			name: poolInfo.Name,
		}
		conn.redisClient = redis.NewClient(&redis.Options{
			Network:  "tcp",
			Addr:     address,
			Password: pwd,
			DB:       poolInfo.DbNum,
			PoolSize: poolInfo.MaxConnect, // default 10
		})

		if i == 0 {
			_, err := conn.redisClient.Ping().Result()
			if err != nil {
				return err
			}
		}
		logger.Sugar.Info("pool ping success,name=", poolInfo.Name)
		// save
		DefaultRedisPool.clientMap[poolInfo.Name] = conn
	}

	// check pool
	if _, ok := DefaultRedisPool.clientMap[KUnreadKeyName]; !ok {
		return errors.New("can't find " + KUnreadKeyName + " pool cache")
	}
	if _, ok := DefaultRedisPool.clientMap[KMsgIdKeyName]; !ok {
		return errors.New("can't find " + KMsgIdKeyName + " pool cache")
	}
	if _, ok := DefaultRedisPool.clientMap[KOnlineKeyName]; !ok {
		return errors.New("can't find " + KOnlineKeyName + " pool cache")
	}
	return nil
}

//
// RedisPool
//

func (r *RedisPool) GetUnreadPool() *RedisConnect {
	return DefaultRedisPool.clientMap[KUnreadKeyName]
}

func (r *RedisPool) GetMsgIdPool() *RedisConnect {
	return DefaultRedisPool.clientMap[KMsgIdKeyName]
}

func (r *RedisPool) GetOnlinePool() *RedisConnect {
	return DefaultRedisPool.clientMap[KOnlineKeyName]
}

//
// RedisConnect
//

func (conn *RedisConnect) Set(key string, value interface{}, expiration time.Duration) *redis.StatusCmd {
	return conn.redisClient.Set(redisKeyPrefix+key, value, expiration)
}

func (conn *RedisConnect) Get(key string) *redis.StringCmd {
	return conn.redisClient.Get(redisKeyPrefix + key)
}

func (conn *RedisConnect) Incr(key string) *redis.IntCmd {
	return conn.redisClient.Incr(redisKeyPrefix + key)
}

// hash
func (conn *RedisConnect) HGetAll(key string) *redis.StringStringMapCmd {
	return conn.redisClient.HGetAll(redisKeyPrefix + key)
}
