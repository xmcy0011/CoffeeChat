/** @file redis.go
 * @brief redis再封装，统一增加前缀"cim|"，支持多个redis db等
 * @author CoffeeChat
 * @date 2019/9/19
 */

package db

import (
	"coffeechat/pkg/logger"
	"errors"
	"fmt"
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

// 删除hash中某个元素
func (conn *RedisConnect) HDel(key string, fields ...string) *redis.IntCmd {
	return conn.redisClient.HDel(redisKeyPrefix+key, fields...)
}

// hash中某个元素是否存在
func (conn *RedisConnect) HExists(key, field string) *redis.BoolCmd {
	return conn.redisClient.HExists(redisKeyPrefix+key, field)
}

// 获取hash中某个key的值
func (conn *RedisConnect) HGet(key, field string) *redis.StringCmd {
	return conn.redisClient.HGet(redisKeyPrefix+key, field)
}

// 获取所有hash元素
func (conn *RedisConnect) HGetAll(key string) *redis.StringStringMapCmd {
	return conn.redisClient.HGetAll(redisKeyPrefix + key)
}

// 自增hash中某个元素
func (conn *RedisConnect) HIncrBy(key, field string, incr int64) *redis.IntCmd {
	return conn.redisClient.HIncrBy(redisKeyPrefix+key, field, incr)
}

//
func (conn *RedisConnect) HIncrByFloat(key, field string, incr float64) *redis.FloatCmd {
	return conn.redisClient.HIncrByFloat(redisKeyPrefix+key, field, incr)
}

// 获取hash中所有元素的key
func (conn *RedisConnect) HKeys(key string) *redis.StringSliceCmd {
	return conn.redisClient.HKeys(redisKeyPrefix + key)
}

// 获取hash元素大小
func (conn *RedisConnect) HLen(key string) *redis.IntCmd {
	return conn.redisClient.HLen(redisKeyPrefix + key)
}

// 获取hash中一个或多个key的值，一次传输，提高性能
func (conn *RedisConnect) HMGet(key string, fields ...string) *redis.SliceCmd {
	return conn.redisClient.HMGet(redisKeyPrefix+key, fields...)
}

// 设置hash中一个或多个key的值，一次传输，提高性能
func (conn *RedisConnect) HMSet(key string, fields map[string]interface{}) *redis.StatusCmd {
	return conn.redisClient.HMSet(redisKeyPrefix+key, fields)
}

// 设置hash中某个key的值
func (conn *RedisConnect) HSet(key, field string, value interface{}) *redis.BoolCmd {
	return conn.redisClient.HSet(redisKeyPrefix+key, field, value)
}

// 设置hash中某个不存在key的值
func (conn *RedisConnect) HSetNX(key, field string, value interface{}) *redis.BoolCmd {
	return conn.redisClient.HSetNX(redisKeyPrefix+key, field, value)
}

// 获取hash表中所有的值
func (conn *RedisConnect) HVals(key string) *redis.StringSliceCmd {
	return conn.redisClient.HVals(redisKeyPrefix + key)
}
