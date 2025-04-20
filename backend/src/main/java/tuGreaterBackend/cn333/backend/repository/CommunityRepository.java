package tuGreaterBackend.cn333.backend.repository;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import tuGreaterBackend.cn333.backend.entity.CommunityPost;

@Repository
public interface CommunityRepository extends MongoRepository<CommunityPost,String> {
    public List<CommunityPost> findAllByOrderByCreatedAtDesc();
    public List<CommunityPost> findByCategory(String category);
    public List<CommunityPost> findByTitleContainingIgnoreCase(String title);
    public List<CommunityPost> findByUserId(String userId);
    public List<CommunityPost> findByRepostedPostId(String repostedPostId);
    public List<CommunityPost> findByRepostedUserId(String repostedUserId);
    public boolean existsByRepostedUserIdAndRepostedPostId(String userId, String repostedPostId);
    public void deleteByRepostedPostId(String repostedPostId);
}
