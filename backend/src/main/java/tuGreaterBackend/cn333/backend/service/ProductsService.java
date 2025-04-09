package tuGreaterBackend.cn333.backend.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tuGreaterBackend.cn333.backend.entity.Products;
import tuGreaterBackend.cn333.backend.repository.ProductsRepository;

import java.util.List;

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
}
