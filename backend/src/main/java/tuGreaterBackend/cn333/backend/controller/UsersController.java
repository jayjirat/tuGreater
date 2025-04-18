package tuGreaterBackend.cn333.backend.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.Valid;
import tuGreaterBackend.cn333.backend.dto.DisplayNameResponse;
import tuGreaterBackend.cn333.backend.dto.UpdateDisplayNameRequest;
import tuGreaterBackend.cn333.backend.entity.Users;
import tuGreaterBackend.cn333.backend.service.UsersService;

@RestController
@RequestMapping("/users")
public class UsersController {

    private final UsersService usersService;

    public UsersController(UsersService usersService) {
        this.usersService = usersService;
    }

    @GetMapping("")
    public ResponseEntity<?> getUsers() {
        try {
            List<Users> users = usersService.getUsers();
            if (users.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
            }
            return ResponseEntity.ok(users);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }

    }

    @GetMapping("/{userId}")
    public ResponseEntity<?> getUserById(@PathVariable String userId) {
        try {
            Users user = usersService.getUserById(userId);
            if (user == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("message", "User not found by id: " + userId));
            }
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }

    @GetMapping("/studentId")
    public ResponseEntity<?> getUserByStydentId(@RequestParam String studentId) {
        try {
            Users user = usersService.getUserByStudentId(studentId);
            if (user == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("message", "User not found by id: " + studentId));
            }
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }

    }

    @PostMapping("")
    public ResponseEntity<?> postUser(@RequestBody Users user) {
        try {
            Users newUser = usersService.saveUser(user);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(Map.of("message", "User created", "user", newUser));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> putUser(@PathVariable String id, @RequestBody Users user) {

        try {
            Users updateUser = usersService.updateUser(id, user);
            if (updateUser == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("message", "User not found by id: " + id));
            }
            return ResponseEntity.ok(updateUser);

        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable String id) {
        try {
            usersService.deleteUser(id);
            return ResponseEntity.ok(Map.of("message", "User deleted successfully"));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }

    @PostMapping("/student/{userId}/displayName")
    public ResponseEntity<?> updateDisplayNameByStudentId(
            @PathVariable String userId,
            @RequestBody @Valid UpdateDisplayNameRequest request) {
        try {
            Users updatedUser = usersService.updateDisplayNameById(userId, request.getDisplayName());
            return ResponseEntity.ok(updatedUser);
        } catch (RuntimeException e) {
            return ResponseEntity.status(404).body(e.getMessage());
        }
    }

    @GetMapping("/student/{userId}/displayName")
    public ResponseEntity<?> getDisplayNameByStudentId(@PathVariable String userId) {
        try {
            String displayName = usersService.getDisplayNameById(userId);
            return ResponseEntity.ok(new DisplayNameResponse(displayName));
        } catch (RuntimeException e) {
            return ResponseEntity.status(404).body(e.getMessage());
        }
    }

    @PutMapping("/profile-image/{userId}")
    public ResponseEntity<?> updateProfileImage(
            @PathVariable String userId,
            @RequestBody Map<String, String> payload) {
        try {
            String imageUrl = payload.get("imageUrl");
            Users updatedUser = usersService.updateProfileImage(userId, imageUrl);

            if (updatedUser != null) {
                return ResponseEntity.ok(updatedUser);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to update profile image: " + e.getMessage());
        }
    }
}
