package tuGreaterBackend.cn333.backend.repository;
import java.util.List;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;
import tuGreaterBackend.cn333.backend.entity.Products;

@Repository
public interface ProductsRepository extends MongoRepository<Products,String> {
    @Query("{ 'productName': { $regex: ?0, $options: 'i' } }")
    List<Products> findByNameRegex(String productName);

    List<Products> findByCategory(String productCategory);
}
