package tuGreaterBackend.cn333.backend.controller;

import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import tuGreaterBackend.cn333.backend.entity.Products;
import tuGreaterBackend.cn333.backend.service.ProductsService;

@RestController
@RequestMapping("/shop")
public class ProductsController {

    private final ProductsService productsService;

    public ProductsController(ProductsService productsService) {
        this.productsService = productsService;
    }

    @PostMapping
    public Products createProduct(@RequestBody Products product){
        return productsService.createProducts(product);
    }

    @GetMapping
    public List<Products> getAllProducts() {return productsService.findAllProducts();}

    @GetMapping("/{productId}")
    public Products getProductsById(@PathVariable String productId){
        return productsService.findProductById(productId);
    }

    @GetMapping("/search")
    public List<Products> searchProducts(@RequestParam String productName){
        return productsService.searchProducts(productName);
    }

    @GetMapping("/product/{productCategory}")
    public List<Products> getCategory(@PathVariable String productCategory){
        return productsService.findProductsByCategory(productCategory);
    }

    @GetMapping("/searchByCategoryAndName")
    public List<Products> searchProductsByCategoryAndName(@RequestParam String category, @RequestParam String name) {
        return productsService.searchProductsByCategoryAndName(category, name);
    }

    @GetMapping("/manage/{productOwnerId}")
    public List<Products> getAllProductsByProductOwnerId(@PathVariable String productOwnerId){
        return productsService.findProductByProductOwnerId(productOwnerId);
    }

    @DeleteMapping("/{productOwnerId}/{productId}")
    public ResponseEntity<String> deleteProductByProductOwnerId(@PathVariable String productOwnerId, @PathVariable String productId){
        boolean isDeleted = productsService.deleteProduct(productOwnerId, productId);
        if (isDeleted) {
            return ResponseEntity.ok("Product deleted successfully.");
        } else {
            return ResponseEntity.status(404).body("Product not found.");
        }
    }

    @PutMapping("/{productOwnerId}/{productId}")
    public ResponseEntity<Products> updateProduct(@PathVariable String productOwnerId, @PathVariable String productId,@RequestBody Map<String, Object> updatedFields){
        try {
            Products updatedProduct = productsService.updateProduct(productOwnerId, productId, updatedFields);
            return new ResponseEntity<>(updatedProduct, HttpStatus.OK);
        } catch (NoSuchElementException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
