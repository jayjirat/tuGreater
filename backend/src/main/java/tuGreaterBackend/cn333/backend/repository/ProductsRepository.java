package tuGreaterBackend.cn333.backend.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import tuGreaterBackend.cn333.backend.entity.Products;

@Repository
public interface ProductsRepository extends MongoRepository<Products,String> {
}
