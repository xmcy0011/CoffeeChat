/** @file redis.go
 * @brief redis再封装，统一增加前缀"cim|"，支持多个redis db等
 * @author CoffeeChat
 * @date 2019/9/19
 */

package dao

import (
	"fmt"
	"github.com/CoffeeChat/server/src/internal/logic/conf"
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

// 禁止更改，全局
var DefaultRedisPool = &RedisPool{}

const kUnreadKeyName = "unread"

func InitCache() error {
	redisConfig := conf.DefaultLogicConfig.Redis
	address := fmt.Sprintf("%s:%d", redisConfig.Ip, redisConfig.Port)

	DefaultRedisPool.clientMap = make(map[string]*RedisConnect)

	for i := 0; i < len(conf.DefaultLogicConfig.Redis.Pool); i++ {
		poolInfo := conf.DefaultLogicConfig.Redis.Pool[i]

		conn := &RedisConnect{
			name: poolInfo.Name,
		}
		conn.redisClient = redis.NewClient(&redis.Options{
			Network:  "tcp",
			Addr:     address,
			Password: redisConfig.Password,
			DB:       poolInfo.DbNum,
			PoolSize: poolInfo.MaxConnect, // default 10
		})

		if i == 0 {
			_, err := conn.redisClient.Ping().Result()
			if err != nil {
				return err
			}
		}

		// save
		DefaultRedisPool.clientMap[poolInfo.Name] = conn
	}

	return nil
}

//
// RedisPool
//

func (r *RedisPool) GetUnreadPool() *RedisConnect {
	return DefaultRedisPool.clientMap[kUnreadKeyName]
}

//
// RedisConnect
//

func (conn *RedisConnect) Set(key string, value interface{}, expiration time.Duration) *redis.StatusCmd {
	return conn.redisClient.Set(conf.DefaultLogicConfig.Redis.KeyPrefix+key, value, expiration)
}

func (conn *RedisConnect) Get(key string) *redis.StringCmd {
	return conn.redisClient.Get(conf.DefaultLogicConfig.Redis.KeyPrefix + key)
}
