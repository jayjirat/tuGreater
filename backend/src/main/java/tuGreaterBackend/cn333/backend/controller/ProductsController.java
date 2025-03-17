package tuGreaterBackend.cn333.backend.controller;

import org.springframework.web.bind.annotation.*;
import tuGreaterBackend.cn333.backend.entity.Products;
import tuGreaterBackend.cn333.backend.service.ProductsService;

import java.util.List;

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

    @GetMapping("/{category}")
    public List<Products> getCategory(@PathVariable String productCategory){
        return productsService.findProductsByCategory(productCategory);
    }
}
