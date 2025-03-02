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

    public List<Users> getUsers() throws Exception{
        try {
            return usersRepository.findAll();
        } catch (Exception e) {
            throw  new Exception("An error occurred while fetching users " ,e);
        }
    }

    public Users getUserById(String id) throws Exception{
        try {
            return usersRepository.findById(id).orElse(null);
        } catch (Exception e) {
            throw  new Exception("An error occurred while fetching user by id: " + id ,e);
        }
    }

    public Users saveUser(Users user) throws Exception{
        try {
            return usersRepository.save(user);
        } catch (RuntimeException e) {
            throw new RuntimeException("Failed to create new user", e);
        } catch (Exception e) {
            throw  new Exception("An error occurred while saving user ",e);
        }
        
    }

    public void deleteUser(String id) throws Exception{
        try {
            usersRepository.deleteById(id);
        } catch (RuntimeException e) {
            throw new RuntimeException("Failed to delete new user", e);
        } catch (Exception e) {
            throw  new Exception("An error occurred while deleting user ",e);
        }
    }

    public Users updateUser(String id,Users user) throws Exception{
        try {
            Users existingUser = usersRepository.findById(id).orElse(null);
            if (existingUser!= null) {
                existingUser.setUsername(user.getUsername());
                existingUser.setPassword(user.getPassword());
                existingUser.setDisplayName(user.getDisplayName());
                existingUser.setProfileImageUrl(user.getProfileImageUrl());
                existingUser.setRole(user.getRole());
                existingUser.setStudentId(user.getStudentId());
                return usersRepository.save(existingUser);
            }else{
                return null;
            }
        } catch (Exception e) {
            throw  new Exception("An error occurred while updating user ",e);
        }
        
    }

}
