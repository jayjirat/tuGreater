package tuGreaterBackend.cn333.backend.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import tuGreaterBackend.cn333.backend.entity.Comment;
import tuGreaterBackend.cn333.backend.entity.CommunityPost;
import tuGreaterBackend.cn333.backend.repository.CommentRepository;
import tuGreaterBackend.cn333.backend.repository.CommunityRepository;

@Service
public class CommentService {

    @Autowired
    private final CommentRepository commentRepository;

    @Autowired
    private final CommunityRepository communityRepository;

    public CommentService(CommentRepository commentRepository,CommunityRepository communityRepository) {
        this.commentRepository = commentRepository;
        this.communityRepository = communityRepository;
    }

    public List<Comment> getCommentsByPostId(String postId) throws Exception {
        try {
            List<Comment> commentsPost = commentRepository.findByPostId(postId);

            return commentsPost;
        }catch (RuntimeException e){
            throw new RuntimeException(e.getMessage());
        } 
        catch (Exception e) {
            throw new Exception("Unexpected error occurred while fetching all posts", e);
        }
    }

    public Comment createComment(Comment comment) throws Exception{
        try{
            Optional<CommunityPost> communityPostOptional = communityRepository.findById(comment.getPostId());
            if (communityPostOptional.isPresent()) {
                CommunityPost communityPost = communityPostOptional.get();
                communityPost.setCommentCount(communityPost.getCommentCount() + 1);  
                communityRepository.save(communityPost); 
            }
            return commentRepository.save(comment);
        }catch (RuntimeException e){
            throw new RuntimeException(e.getMessage());
        } 
        catch (Exception e) {
            throw new Exception("Unexpected error occurred while fetching all posts", e);
        }
    }

    @Transactional
    public void deleteComment(String postId,String commentId) throws Exception{
        try{
            Optional<CommunityPost> communityPostOptional = communityRepository.findById(postId);
            if (communityPostOptional.isPresent()) {
                CommunityPost communityPost = communityPostOptional.get();
                communityPost.setCommentCount(communityPost.getCommentCount() - 1);  
                communityRepository.save(communityPost); 
            }
            commentRepository.deleteById(commentId);
        }catch (RuntimeException e){
            throw new RuntimeException(e.getMessage());
        } 
        catch (Exception e) {
            throw new Exception("Unexpected error occurred while fetching all posts", e);
        }
    }


}
