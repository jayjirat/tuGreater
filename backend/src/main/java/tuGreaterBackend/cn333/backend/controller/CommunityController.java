package tuGreaterBackend.cn333.backend.controller;

import java.util.HashMap;
import java.util.List;

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

import tuGreaterBackend.cn333.backend.entity.CommunityPost;
import tuGreaterBackend.cn333.backend.service.CommunityService;


@RestController
@RequestMapping("/community")
public class CommunityController {
    private final CommunityService communityService;

    public CommunityController(CommunityService communityService) {
        this.communityService = communityService;
    }

    @GetMapping("")
    public ResponseEntity<?> getPosts() {
        try {
            List<CommunityPost> communityPost = communityService.getCommunityPosts();
            return ResponseEntity.ok(communityPost);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getPost(@PathVariable String id) {
        try {
            CommunityPost communityPost = communityService.getCommunityPost(id);
            return ResponseEntity.ok(communityPost);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }
    
    @PostMapping("")
    public ResponseEntity<?> postPost(@RequestBody CommunityPost communityPost) {
        try {
            CommunityPost newCommunityPost = communityService.createCommunityPost(communityPost);
            return ResponseEntity.status(HttpStatus.CREATED).body(newCommunityPost);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> putPost(@PathVariable String id,@RequestBody CommunityPost communityPost) {
        try {
            CommunityPost editCommunityPost = communityService.updateCommunityPost(id,communityPost);
            return ResponseEntity.ok(editCommunityPost);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletePost(@PathVariable String id){
        try {
            communityService.deleteCommunityPost(id);
            return ResponseEntity.ok(new HashMap<String, String>() {{
                put("message", "Post deleted successfully");
            }});
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }  
    
    @GetMapping("/filter")
    public ResponseEntity<?> getPostsByCategory(@RequestParam String category) {
        try {
            List<CommunityPost> communityPost = communityService.getCategoryPosts(category);
            return ResponseEntity.ok(communityPost);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }
    
    @GetMapping("/search")
    public ResponseEntity<?> getPostsByQuery(@RequestParam String query) {
        try {
            List<CommunityPost> communityPost = communityService.getPostsByQueryTitle(query);
            return ResponseEntity.ok(communityPost);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }

    @GetMapping("/me/{userId}")
    public ResponseEntity<?> getUserPosts(@PathVariable String userId) {
        try {
            List<CommunityPost> userPost = communityService.getUserPosts(userId);
            return ResponseEntity.ok(userPost);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }
    

}
