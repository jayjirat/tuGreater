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

    public List<Users> getUsers() throws Exception {
        try {
            return usersRepository.findAll();
        } catch (Exception e) {
            throw new Exception("An error occurred while fetching users ", e);
        }
    }

    public Users getUserByStudentId(String studentId) throws Exception {
        try {
            return usersRepository.findByStudentId(studentId);
        } catch (Exception e) {
            throw new Exception("An error occurred while fetching user by id: " + studentId, e);
        }
    }

    public Users saveUser(Users user) throws Exception {
        try {
            return usersRepository.save(user);
        } catch (RuntimeException e) {
            throw new RuntimeException("Failed to create new user", e);
        } catch (Exception e) {
            throw new Exception("An error occurred while saving user ", e);
        }

    }

    public void deleteUser(String id) throws Exception {
        try {
            usersRepository.deleteById(id);
        } catch (RuntimeException e) {
            throw new RuntimeException("Failed to delete new user", e);
        } catch (Exception e) {
            throw new Exception("An error occurred while deleting user ", e);
        }
    }

    public Users updateUser(String id, Users user) throws Exception {
        try {
            Users existingUser = usersRepository.findById(id).orElse(null);
            if (existingUser != null) {
                existingUser.setUsername(user.getUsername());
                existingUser.setDisplayName(user.getDisplayName());
                existingUser.setProfileImageUrl(user.getProfileImageUrl());
                existingUser.setRole(user.getRole());
                existingUser.setStudentId(user.getStudentId());
                Users editedUser = usersRepository.save(existingUser);
                return editedUser;
            } else {
                return null;
            }
        } catch (Exception e) {
            throw new Exception("An error occurred while updating user ", e);
        }

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

    public Users updateProfileImage(String studentId, String profileImageUrl) throws Exception {
        try {
            Users existingUser = usersRepository.findByStudentId(studentId);

            if (existingUser != null) {
                existingUser.setProfileImageUrl(profileImageUrl);

                Users updatedUser = usersRepository.save(existingUser);
                return updatedUser;
            } else {
                return null;
            }
        } catch (Exception e) {
            throw new Exception("An error occurred while updating profile image", e);
        }
    }

}
