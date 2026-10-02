package workout.auth.service.impl;

import workout.auth.dao.AuthDAO;
import workout.auth.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service("authService")
public class AuthServiceImpl implements AuthService {

    @Autowired
    private AuthDAO authDAO;

    @Override
    public Map<String, Object> selectUserByUsername(String username) {
        return authDAO.selectUserByUsername(username);
    }

    @Override
    public String selectPasswordHash(long userId) {
        return authDAO.selectPasswordHash(userId);
    }

    @Override
    public int updatePassword(Map<String, Object> param) {
        return authDAO.updatePassword(param);
    }

    @Override
    public int insertUser(Map<String, Object> param) {
        return authDAO.insertUser(param);
    }
}
