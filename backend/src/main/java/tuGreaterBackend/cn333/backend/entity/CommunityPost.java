package tuGreaterBackend.cn333.backend.entity;

import java.time.LocalDateTime;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "communityPost")
public class CommunityPost {
    @Id
    private String id;

    private String title;
    private String description;
    private String category;
    private int likeCount;
    private int commentCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String userId;
    private String username;
    private boolean isEdited;
    private String imageUrl;
    private String postedByImageUrl;

    public String getId() {
        return this.id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return this.title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return this.description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return this.category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getLikeCount() {
        return this.likeCount;
    }

    public void setLikeCount(int likeCount) {
        this.likeCount = likeCount;
    }

    public int getCommentCount() {
        return this.commentCount;
    }

    public void setCommentCount(int commentCount) {
        this.commentCount = commentCount;
    }

    public LocalDateTime getCreatedAt() {
        return this.createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return this.updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getUserId() {
        return this.userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return this.username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public boolean isIsEdited() {
        return this.isEdited;
    }

    public boolean getIsEdited() {
        return this.isEdited;
    }

    public void setIsEdited(boolean isEdited) {
        this.isEdited = isEdited;
    }

    public String getImageUrl() {
        return this.imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getPostedByImageUrl() {
        return this.postedByImageUrl;
    }

    public void setPostedByImageUrl(String postedByImageUrl) {
        this.postedByImageUrl = postedByImageUrl;
    }

}
