package tuGreaterBackend.cn333.backend.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import tuGreaterBackend.cn333.backend.entity.Report;

@Repository
public interface ReportRepository extends MongoRepository<Report, String>{
}

