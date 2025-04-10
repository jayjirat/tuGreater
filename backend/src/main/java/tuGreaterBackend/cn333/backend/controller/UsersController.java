package tuGreaterBackend.cn333.backend.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.Valid;
import tuGreaterBackend.cn333.backend.service.UsersService;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
// import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import tuGreaterBackend.cn333.backend.dto.*;
import tuGreaterBackend.cn333.backend.entity.Users;

@RestController
@RequestMapping("/api")
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

    @PostMapping("")
    public ResponseEntity<?> createUser(@RequestBody Users user) {
        Users savedUser = usersService.createUser(user);
        return ResponseEntity.ok(savedUser);
    }

    @PostMapping("/{id}/displayName")
    public ResponseEntity<?> updateDisplayName(
            @PathVariable String id,
            @RequestBody UpdateDisplayNameRequest request) {
        Users updatedUser = usersService.updateDisplayName(id, request.getDisplayName());
        return ResponseEntity.ok(updatedUser);
    }

    @PostMapping("/student/{studentId}/displayName")
    public ResponseEntity<?> updateDisplayNameByStudentId(
            @PathVariable String studentId,
            @RequestBody @Valid UpdateDisplayNameRequest request) {
        try {
            Users updatedUser = usersService.updateDisplayNameByStudentId(studentId, request.getDisplayName());
            return ResponseEntity.ok(updatedUser);
        } catch (RuntimeException e) {
            return ResponseEntity.status(404).body(e.getMessage());
        }
    }

    @GetMapping("/student/{studentId}/displayName")
    public ResponseEntity<?> getDisplayNameByStudentId(@PathVariable String studentId) {
        try {
            String displayName = usersService.getDisplayNameByStudentId(studentId);
            return ResponseEntity.ok(new DisplayNameResponse(displayName));
        } catch (RuntimeException e) {
            return ResponseEntity.status(404).body(e.getMessage());
        }
    }

}
