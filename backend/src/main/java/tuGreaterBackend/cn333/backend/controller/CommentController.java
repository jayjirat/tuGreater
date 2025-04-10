package tuGreaterBackend.cn333.backend.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import tuGreaterBackend.cn333.backend.entity.Comment;
import tuGreaterBackend.cn333.backend.service.CommentService;



@RestController
@RequestMapping("/community/{id}/comment")
public class CommentController {
    private final CommentService commentService;

    public CommentController(CommentService commentService) {
        this.commentService = commentService;
    }

    @GetMapping("")
    public ResponseEntity<?> getCommentsByPostId(@PathVariable("id") String postId) {
        try {
            List<Comment> commentsPost = commentService.getCommentsByPostId(postId);
            return ResponseEntity.ok(commentsPost);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }

    @PostMapping("")
    public ResponseEntity<?> postComment(@PathVariable("id") String postId,@RequestBody Comment comment) {
        try {
            Comment newComment = commentService.createComment(comment);
            return ResponseEntity.status(HttpStatus.CREATED).body(newComment);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }

    @DeleteMapping("/{commentId}")
    public ResponseEntity<?> deleteComment(@PathVariable("id") String postId,@PathVariable("commentId") String commentId) {
        try {
            commentService.deleteComment(postId,commentId);
            return ResponseEntity.ok(new HashMap<String, String>() {{
                put("message", "Comment deleted successfully");
            }});
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }
    
    
}
