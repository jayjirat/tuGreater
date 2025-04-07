package tuGreaterBackend.cn333.backend.service;

import java.time.LocalDateTime;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import tuGreaterBackend.cn333.backend.entity.CommunityPost;
import tuGreaterBackend.cn333.backend.entity.Like;
import tuGreaterBackend.cn333.backend.repository.CommunityRepository;
import tuGreaterBackend.cn333.backend.repository.LikeRepository;

@Service
public class LikeService {

    @Autowired
    private final LikeRepository likeRepository;

    @Autowired
    private final CommunityRepository communityRepository;

    public LikeService(LikeRepository likeRepository, CommunityRepository communityRepository) {
        this.likeRepository = likeRepository;
        this.communityRepository = communityRepository;
    }

    @Transactional
    public void addLike(String userId, String postId) {
        try {
            Like like = new Like();
            like.setUserId(userId);
            like.setPostId(postId);
            like.setCreatedAt(LocalDateTime.now());
            likeRepository.save(like);  

            Optional<CommunityPost> communityPostOptional = communityRepository.findById(postId);
            if (communityPostOptional.isPresent()) {
                CommunityPost communityPost = communityPostOptional.get();
                communityPost.setLikeCount(communityPost.getLikeCount() + 1);  
                communityRepository.save(communityPost); 
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to add like to post ID " + postId, e);
        }
    }

    @Transactional
    public void removeLike(String userId, String postId) {
        try {
            Optional<Like> likeOptional = likeRepository.findByUserIdAndPostId(userId, postId);
            if(likeOptional.isPresent()){
                Like like = likeOptional.get();
                likeRepository.delete(like);
            }

            Optional<CommunityPost> communityPostOptional = communityRepository.findById(postId);
            if (communityPostOptional.isPresent()) {
                CommunityPost communityPost = communityPostOptional.get();
                communityPost.setLikeCount(communityPost.getLikeCount() - 1);  
                communityRepository.save(communityPost); 
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to add like to post ID " + postId, e);
        }
    }

    public boolean isLiked(String userId, String postId) {
        return likeRepository.findByUserIdAndPostId(userId, postId).isPresent();
    }
}
