package tuGreaterBackend.cn333.backend.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tuGreaterBackend.cn333.backend.entity.Products;
import tuGreaterBackend.cn333.backend.repository.ProductsRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Optional;

@Service
public class ProductsService {
    @Autowired
    private final ProductsRepository productsRepository;

    public ProductsService(ProductsRepository productsRepository) {
        this.productsRepository = productsRepository;
    }

    public Products createProducts(Products product){
        return productsRepository.save(product);
    }

    public List<Products> findAllProducts() {return productsRepository.findAll();}

    public Products findProductById(String productId){
        return productsRepository.findById(productId).get();
    }

    public List<Products> searchProducts(String productName){
        return productsRepository.findByNameRegex(productName);
    }

    public List<Products> findProductsByCategory(String productCategory){
        return productsRepository.findByCategory(productCategory);
    }

    public List<Products> searchProductsByCategoryAndName(String productCategory, String productName){
        return productsRepository.findByCategoryAndName(productCategory,productName);
    }

    public List<Products> findProductByProductOwnerId(String productOwnerId){
        return productsRepository.findByProductOwnerId(productOwnerId);
    }

    public boolean deleteProduct(String productOwnerId,String productId){
        Optional<Products> product = productsRepository.findByProductOwnerIdAndProductId(productOwnerId,productId);
        if(product.isPresent()){
            productsRepository.delete(product.get());
            return true;
        }
        return false;
    }

    public Products updateProduct(String productOwnerId, String productId, Map<String, Object> updatedFields){
        Optional<Products> product = productsRepository.findByProductOwnerIdAndProductId(productOwnerId,productId);
        if (product.isPresent()) {
            Products existingProduct = product.get();

            if (updatedFields.containsKey("productName")) {
                existingProduct.setProductName((String) updatedFields.get("productName"));
            }
            if (updatedFields.containsKey("productPrice")) {
                existingProduct.setProductPrice((Double) updatedFields.get("productPrice"));
            }
            if (updatedFields.containsKey("productDescription")) {
                existingProduct.setProductDescription((String) updatedFields.get("productDescription"));
            }
            if (updatedFields.containsKey("productCategory")) {
                existingProduct.setProductCategory((String) updatedFields.get("productCategory"));
            }
            if (updatedFields.containsKey("productTags")) {
                existingProduct.setProductTags((List<String>) updatedFields.get("productTags"));
            }
            if (updatedFields.containsKey("productImageUrls")) {
                existingProduct.setProductImageUrls((List<String>) updatedFields.get("productImageUrls"));
            }
            if (updatedFields.containsKey("productDateUpdate")) {
                existingProduct.setProductDateUpdate(LocalDateTime.parse((String) updatedFields.get("productDateUpdate")));
            }

            return productsRepository.save(existingProduct);
        } else {
            throw new NoSuchElementException("Product not found with productOwnerId: " + productOwnerId + " and productId: " + productId);
        }
    }
}
