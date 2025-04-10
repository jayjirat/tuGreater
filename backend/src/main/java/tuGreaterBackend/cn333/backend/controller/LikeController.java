package tuGreaterBackend.cn333.backend.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import tuGreaterBackend.cn333.backend.entity.Like;
import tuGreaterBackend.cn333.backend.service.LikeService;

@RestController
@RequestMapping("/community/like")
public class LikeController {
    private final LikeService likeService;

    public LikeController(LikeService likeService) {
        this.likeService = likeService;
    }

    @PostMapping("")
    public ResponseEntity<?> postLike(@RequestBody Like like) {
        try {
            likeService.addLike(like.getUserId(), like.getPostId());
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }

    @DeleteMapping("")
    public ResponseEntity<?> deleteLike(@RequestBody Like like) {
        try {
            likeService.removeLike(like.getUserId(), like.getPostId());
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }

    @GetMapping("")
    public ResponseEntity<?> getLike(@RequestParam String userId, @RequestParam String postId) {
        try {
            return ResponseEntity.ok(likeService.isLiked(userId, postId));
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }
    
    
}
