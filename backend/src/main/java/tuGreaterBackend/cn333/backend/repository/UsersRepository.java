package tuGreaterBackend.cn333.backend.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import tuGreaterBackend.cn333.backend.entity.Users;

@Repository
public interface UsersRepository extends MongoRepository<Users, String> {
    public Users findByStudentId(String studentId);
}
