package tuGreaterBackend.cn333.backend.service;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import tuGreaterBackend.cn333.backend.entity.Users;
import tuGreaterBackend.cn333.backend.repository.UsersRepository;

@Service
public class UsersService {

    @Autowired
    private final UsersRepository usersRepository;

    public UsersService(UsersRepository usersRepository) {
        this.usersRepository = usersRepository;
    }

    public Users createUser(Users user) {
        return usersRepository.save(user);
    }

    public List<Users> getUsers() {
        return usersRepository.findAll();
    }

    public Users updateDisplayName(String id, String newDisplayName) {
        Optional<Users> optionalUser = usersRepository.findById(id);
        if (optionalUser.isPresent()) {
            Users user = optionalUser.get();
            user.setDisplayName(newDisplayName);
            return usersRepository.save(user);
        } else {
            throw new RuntimeException("User not found");
        }
    }

    public Users updateDisplayNameByStudentId(String studentId, String newDisplayName) {
        Users user = usersRepository.findByStudentId(studentId);
        if (user == null) {
            throw new RuntimeException("User with student ID " + studentId + " not found");
        }

        user.setDisplayName(newDisplayName);
        return usersRepository.save(user);
    }

    public String getDisplayNameByStudentId(String studentId) {
        Users user = usersRepository.findByStudentId(studentId);
        if (user == null) {
            throw new RuntimeException("User with student ID " + studentId + " not found");
        }

        String displayName = user.getDisplayName();
        return displayName;
    }

}
