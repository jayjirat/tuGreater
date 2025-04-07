package tuGreaterBackend.cn333.backend.repository;

import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;

import tuGreaterBackend.cn333.backend.entity.Like;

public interface LikeRepository extends MongoRepository<Like,String>{
    public Optional<Like> findByUserIdAndPostId(String userId, String postId);
}
