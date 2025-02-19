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

    @PostMapping("/add")
    public Products createProduct(@RequestBody Products product){
        return productsService.createProducts(product);
    }

    @GetMapping("/all")
    public List<Products> getAllProducts() {return productsService.findAllProducts();}
}
