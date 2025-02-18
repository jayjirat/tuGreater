package tuGreaterBackend.cn333.backend.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
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

    @PostMapping("/add")
    public Products createProduct(@RequestBody Products product){
        return productsService.createProducts(product);
    }


}
