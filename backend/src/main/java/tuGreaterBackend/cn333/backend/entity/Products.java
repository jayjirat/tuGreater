package tuGreaterBackend.cn333.backend.entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.List;

@Document(collection="product")
public class Products {
    @Id
    private String productId;
    private List<String> productImageUrls;
    private String productName;
    private double productPrice;
    private LocalDateTime productDatePost;
    private LocalDateTime productDateUpdate;
    private List<String> productTags;
    private String productDescription;
    private String productCategory;
    private String productOwner;
    private String productOwnerId;

    @Override
    public String toString() {
        return "Products{" +
                "productId='" + productId + '\'' +
                ", productImageUrls=" + productImageUrls +
                ", productName='" + productName + '\'' +
                ", productPrice=" + productPrice +
                ", productDatePost=" + productDatePost +
                ", productDateUpdate=" + productDateUpdate +
                ", productTags=" + productTags +
                ", productDescription='" + productDescription + '\'' +
                ", productCategory='" + productCategory + '\'' +
                ", productOwner='" + productOwner + '\'' +
                ", productOwnerId='" + productOwnerId + '\'' +
                '}';
    }

    public void setId(String productId) {
        this.productId = productId;
    }

    public Products(){

    }

    public Products(String productId, List<String> productImageUrls, String productName, double productPrice, String productDescription, String productCategory, LocalDateTime productDatePost,LocalDateTime productDateUpdate, List<String> productTags,String productOwner,String productOwnerId) {
        this.productId = productId;
        this.productImageUrls = productImageUrls;
        this.productName = productName;
        this.productPrice = productPrice;
        this.productDescription = productDescription;
        this.productCategory = productCategory;
        this.productDatePost = productDatePost;
        this.productDateUpdate = productDateUpdate;
        this.productTags = productTags;
        this.productOwner = productOwner;
        this.productOwnerId = productOwnerId;
    }


    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public double getProductPrice() {
        return productPrice;
    }

    public void setProductPrice(double productPrice) {
        this.productPrice = productPrice;
    }

    public String getProductDescription() {
        return productDescription;
    }

    public void setProductDescription(String productDescription) {
        this.productDescription = productDescription;
    }

    public String getProductCategory() {
        return productCategory;
    }

    public void setProductCategory(String productCategory) {
        this.productCategory = productCategory;
    }

    public LocalDateTime getProductDatePost() {
        return productDatePost;
    }

    public void setProductDatePost(LocalDateTime productDatePost) {
        this.productDatePost = productDatePost;
    }

    public List<String> getProductTags() {
        return productTags;
    }

    public void setProductTags(List<String> productTags) {
        this.productTags = productTags;
    }

    public String getProductOwnerId() {
        return productOwnerId;
    }

    public void setProductOwnerId(String productOwnerId) {
        this.productOwnerId = productOwnerId;
    }

    public LocalDateTime getProductDateUpdate() {
        return productDateUpdate;
    }

    public void setProductDateUpdate(LocalDateTime productDateUpdate) {
        this.productDateUpdate = productDateUpdate;
    }

    public String getProductOwner() {
        return productOwner;
    }

    public void setProductOwner(String productOwner) {
        this.productOwner = productOwner;
    }

    public List<String> getProductImageUrls() {
        return productImageUrls;
    }

    public void setProductImageUrls(List<String> productImageUrls) {
        this.productImageUrls = productImageUrls;
    }

    public String getId() {
        return productId;
    }

}
