package tuGreaterBackend.cn333.backend.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import tuGreaterBackend.cn333.backend.entity.CommunityPost;
import tuGreaterBackend.cn333.backend.repository.CommunityRepository;

@Service
public class CommunityService {

    @Autowired
    private final CommunityRepository communityRepository;

    public CommunityService(CommunityRepository communityRepository) {
        this.communityRepository = communityRepository;
    }

    public List<CommunityPost> getCommunityPosts() throws Exception{
        try {
            List<CommunityPost> communityPosts = communityRepository.findAll();

            if (communityPosts.isEmpty()) {
                throw new RuntimeException("No posts found. Please try again later.");
            }
            return communityPosts;
        }catch (RuntimeException e){
            throw new RuntimeException(e.getMessage());
        } 
        catch (Exception e) {
            throw new Exception("Unexpected error occurred while fetching all posts", e);
        }
    }

    public CommunityPost getCommunityPost(String id) throws Exception{
        try {
            CommunityPost communityPost = communityRepository.findById(id).orElse(null);
            if (communityPost == null) {
                throw new RuntimeException("Post not found by id: " + id);
            }
            return communityPost;
        }catch (RuntimeException e){
            throw new RuntimeException(e.getMessage());
        }  catch (Exception e) {
            throw new Exception("Unexpected error occurred while fetching post id "+ id, e);
        }
    }

    public CommunityPost createCommunityPost(CommunityPost communityPost) {
        try {
            return communityRepository.save(communityPost);
        } catch (Exception e) {
            throw new RuntimeException("Failed to create new post", e);
        }
    }

    public CommunityPost updateCommunityPost(String id, CommunityPost communityPost) throws Exception{
        try {

            CommunityPost existingPost = communityRepository.findById(id).orElse(null);

            if (existingPost == null) {
                throw new RuntimeException("Post not found by id: " + id);
            }
            
            existingPost.setDescription(communityPost.getDescription());
            existingPost.setTitle(communityPost.getTitle());
            existingPost.setIsEdited(true);
            existingPost.setUpdatedAt(new Date());
            return communityRepository.save(existingPost);

        } catch (RuntimeException e) {
            throw new RuntimeException("Failed to update post by id: " + id, e);
        } catch (Exception e) {
            throw new Exception("Unexpected error occurred while updating post by id: " + id, e);
        }
    }
    
    public void deleteCommunityPost(String id) {
        try {
            communityRepository.deleteById(id);
        } catch (Exception e) {
            throw new RuntimeException("Failed to delete post by id: " + id, e);
        }
    }

    ;

    public List<CommunityPost> getCategoryPosts(String category) throws Exception {
        try {
            List<CommunityPost> fliterPosts = communityRepository.findByCategory(category);

            if(fliterPosts.isEmpty()){
                throw new RuntimeException("No posts found for category: " + category);
            }
            return fliterPosts;
        } catch (RuntimeException e) {
            throw new RuntimeException(e.getMessage());
        } catch (Exception e) {
            throw new Exception("Unexpected error occurred while fetching post by category: " + category, e);
        }
    }

    public List<CommunityPost> getPostsByQueryTitle(String query) throws Exception {
        try {
            List<CommunityPost> queryPosts = communityRepository.findByTitleContainingIgnoreCase(query);
            if(queryPosts.isEmpty()){
                throw new RuntimeException("No posts found for query: " + query);
            }
            return queryPosts;
        } catch (RuntimeException e) {
            throw new RuntimeException(e.getMessage());
        } catch (Exception e) {
            throw new Exception("Unexpected error occurred while fetching post by query: " + query, e);
        }
    }

    public List<CommunityPost> getUserPost(String userId) throws Exception {
        try {
            List<CommunityPost> userPosts = communityRepository.findByUserId(userId);
            if(userPosts.isEmpty()){
                throw new RuntimeException("No posts found for user: " + userId);
            }
            return userPosts;
        } catch (RuntimeException e) {
            throw new RuntimeException(e.getMessage());
        } catch (Exception e) {
            throw new Exception("Unexpected error occurred while fetching user's posts by userId: " + userId, e);
        }
    }
}
