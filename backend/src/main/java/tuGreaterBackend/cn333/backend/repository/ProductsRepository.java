package tuGreaterBackend.cn333.backend.repository;
import java.util.List;
import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;
import tuGreaterBackend.cn333.backend.entity.Products;

@Repository
public interface ProductsRepository extends MongoRepository<Products,String> {
    @Query("{ 'productName': { $regex: ?0, $options: 'i' } }")
    List<Products> findByNameRegex(String productName);

    @Query("{ 'productCategory': ?0 }")
    List<Products> findByCategory(String productCategory);

    @Query("{ 'productCategory': ?0, 'productName': { $regex: ?1, $options: 'i' } }")
    List<Products> findByCategoryAndName(String productCategory, String productName);

    List<Products> findByProductOwnerId(String productOwnerId);

    Optional<Products> findByProductOwnerIdAndProductId(String productOwnerId, String productId);
}
