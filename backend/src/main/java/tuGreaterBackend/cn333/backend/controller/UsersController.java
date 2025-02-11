package tuGreaterBackend.cn333.backend.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import tuGreaterBackend.cn333.backend.service.UsersService;

import org.springframework.web.bind.annotation.GetMapping;
// import org.springframework.web.bind.annotation.RequestParam;

import tuGreaterBackend.cn333.backend.entity.Users;



@RestController
@RequestMapping("/users")
public class UsersController {
    private final UsersService usersService;

    public UsersController(UsersService usersService) {
        this.usersService = usersService;
    }

    @GetMapping("")
    public ResponseEntity<?> getUsers() {
        List<Users> users = usersService.getUsers();

        return ResponseEntity.ok(users);
    }
    
}
