package tuGreaterBackend.cn333.backend.repository;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import tuGreaterBackend.cn333.backend.entity.Comment;

@Repository
public interface CommentRepository extends MongoRepository<Comment ,String> {
    public List<Comment> findByPostId(String postId);
    public List<Comment> findByUserId(String userId);
}
