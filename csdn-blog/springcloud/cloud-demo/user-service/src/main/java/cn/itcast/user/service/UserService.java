package cn.itcast.user.service;

import cn.itcast.user.mapper.UserMapper;
import cn.itcast.user.pojo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    public User queryById(Long id) {
//        try {
//            Thread.sleep(2000L);
//        } catch (InterruptedException e) {
//            e.printStackTrace();
//        }
        User user = userMapper.selectByPrimaryKey(id);
        System.out.println(user);
        return user;
    }
}