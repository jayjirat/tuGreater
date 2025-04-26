package tuGreaterBackend.cn333.backend.repository;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import tuGreaterBackend.cn333.backend.entity.CommunityPost;

@Repository
public interface CommunityRepository extends MongoRepository<CommunityPost,String> {
    public List<CommunityPost> findAllByOrderByCreatedAtDesc();
    public List<CommunityPost> findByCategoryOrderByCreatedAtDesc(String category);
    public List<CommunityPost> findByTitleContainingIgnoreCaseOrderByCreatedAtDesc(String title);
    public List<CommunityPost> findByUserIdAndRepostedUserIdIsNullOrderByCreatedAtDesc(String userId);

    public List<CommunityPost> findByRepostedUserIdOrderByCreatedAtDesc(String repostedUserId);
    public boolean existsByRepostedUserIdAndRepostedPostId(String userId, String repostedPostId);
    public void deleteByRepostedPostId(String repostedPostId);
}
