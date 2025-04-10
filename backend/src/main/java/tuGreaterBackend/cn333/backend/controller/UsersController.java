package tuGreaterBackend.cn333.backend.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import tuGreaterBackend.cn333.backend.entity.Users;
import tuGreaterBackend.cn333.backend.service.UsersService;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PutMapping;


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
            if(users.isEmpty()){
                return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
            }
            return ResponseEntity.ok(users);
        } catch (Exception e){
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
        
    }

    @GetMapping("/{studentId}")
    public ResponseEntity<?> getUser(@PathVariable String studentId) {
        try {
            Users user = usersService.getUserByStudentId(studentId);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("message", "User not found by id: " + studentId));
        }
        return ResponseEntity.ok(user);
        } catch (Exception e){
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
            Users updateUser = usersService.updateUser(id,user);
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

    

    
    
}
