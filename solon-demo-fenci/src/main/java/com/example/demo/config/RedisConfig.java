package com.example.demo.config;

import com.example.demo.utils.ResourceChangeNotifier;
import org.apdplat.word.util.WordConfTools;
import org.noear.solon.annotation.Configuration;
import org.noear.solon.annotation.Init;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

@Configuration
public class RedisConfig {

    @Init
    public void initRedis() {
        String host = WordConfTools.get("redis.host", "localhost");
        int port = WordConfTools.getInt("redis.port", 6379);
        JedisPoolConfig jedispool_config = new JedisPoolConfig();
        JedisPool jedisPool = new JedisPool(jedispool_config, host, port);
        ResourceChangeNotifier.setJedisPool(jedisPool);
    }

}
