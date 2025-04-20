package tuGreaterBackend.cn333.backend.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;

import tuGreaterBackend.cn333.backend.entity.Comment;
import tuGreaterBackend.cn333.backend.entity.CommunityPost;
import tuGreaterBackend.cn333.backend.entity.Products;
import tuGreaterBackend.cn333.backend.entity.Users;
import tuGreaterBackend.cn333.backend.repository.CommentRepository;
import tuGreaterBackend.cn333.backend.repository.CommunityRepository;
import tuGreaterBackend.cn333.backend.repository.ProductsRepository;
import tuGreaterBackend.cn333.backend.repository.UsersRepository;

@Service
public class UsersService {

    @Autowired
    private final UsersRepository usersRepository;

    @Autowired
    private final CommunityRepository communityRepository;

    @Autowired
    private final CommentRepository commentRepository;

    @Autowired
    private final ProductsRepository productsRepository;

    @Autowired
    private MongoTemplate mongoTemplate;


    public UsersService(UsersRepository usersRepository,CommunityRepository communityRepository,ProductsRepository productsRepository,CommentRepository commentRepository) {
        this.usersRepository = usersRepository;
        this.communityRepository = communityRepository;
        this.productsRepository = productsRepository;
        this.commentRepository = commentRepository;
    }

    public List<Users> getUsers() throws Exception {
        try {
            return usersRepository.findAll();
        } catch (Exception e) {
            throw  new Exception("An error occurred while fetching users " ,e);
        }
    }


    public Users getUserByStudentId(String studentId) throws Exception {
        try {
            return usersRepository.findByStudentId(studentId);
        } catch (Exception e) {
            throw new Exception("An error occurred while fetching user by id: " + studentId, e);
        }
    }

    public Users getUserById(String userId) throws Exception {
        try {
            return usersRepository.findById(userId).orElse(null);
        } catch (Exception e) {
            throw new Exception("An error occurred while fetching user by id: " + userId, e);
        }
    }

    public Users saveUser(Users user) throws Exception {
        try {
            return usersRepository.save(user);
        } catch (RuntimeException e) {
            throw new RuntimeException("Failed to create new user", e);
        } catch (Exception e) {
            throw new Exception("An error occurred while saving user ", e);
        }

    }

    public void deleteUser(String id) throws Exception {
        try {
            usersRepository.deleteById(id);
        } catch (RuntimeException e) {
            throw new RuntimeException("Failed to delete new user", e);
        } catch (Exception e) {
            throw new Exception("An error occurred while deleting user ", e);
        }
    }

    public Users updateUser(String id, Users user) throws Exception {
        try {
            Users existingUser = usersRepository.findById(id).orElse(null);
            if (existingUser != null) {
                existingUser.setUsername(user.getUsername());
                existingUser.setDisplayName(user.getDisplayName());
                existingUser.setProfileImageUrl(user.getProfileImageUrl());
                existingUser.setRole(user.getRole());
                existingUser.setStudentId(user.getStudentId());
                Users editedUser = usersRepository.save(existingUser);
                return editedUser;
            } else {
                return null;
            }
        } catch (Exception e) {
            throw new Exception("An error occurred while updating user ", e);
        }

    }

    public Users updateDisplayName(String id, String newDisplayName) {
        Optional<Users> optionalUser = usersRepository.findById(id);
        if (optionalUser.isPresent()) {
            Users user = optionalUser.get();
            user.setDisplayName(newDisplayName);
            List<CommunityPost> posts = communityRepository.findByUserId(id);
            if (!posts.isEmpty()) {
                for (CommunityPost post : posts) {
                    post.setUsername(newDisplayName);
                }
                communityRepository.saveAll(posts);
            }

            List<Products> products = productsRepository.findByProductOwnerId(id);
            if (!products.isEmpty()) {
                for (Products product : products) {
                    product.setProductOwner(newDisplayName);
                }
                productsRepository.saveAll(products);
            }  
            return usersRepository.save(user);
        } else {
            throw new RuntimeException("User not found");
        }
    }

    public Users updateDisplayNameById(String userId, String newDisplayName) {
    Optional<Users> optionalUser = usersRepository.findById(userId);
    if (optionalUser.isEmpty()) {
        throw new RuntimeException("User with student ID " + userId + " not found");
    }

    Users user = optionalUser.get();
    user.setDisplayName(newDisplayName);

    Query query1 = new Query(Criteria.where("userId").is(userId));
    Update update1 = new Update().set("username", newDisplayName);
    mongoTemplate.updateMulti(query1, update1, CommunityPost.class);

    Query query2 = new Query(Criteria.where("repostedUserId").is(userId));
    Update update2 = new Update().set("repostedUsername", newDisplayName);
    mongoTemplate.updateMulti(query2, update2, CommunityPost.class);

    Query query3 = new Query(Criteria.where("userId").is(userId));
    Update update3 = new Update().set("username", newDisplayName);
    mongoTemplate.updateMulti(query3, update3, Comment.class);

    Query query4 = new Query(Criteria.where("productOwnerId").is(userId));
    Update update4 = new Update().set("productOwner", newDisplayName);
    mongoTemplate.updateMulti(query4, update4, Products.class);

    return usersRepository.save(user);
}

    public String getDisplayNameById(String userId) {
        Optional<Users> optionalUser = usersRepository.findById(userId);
        if (optionalUser.isPresent()) {
            Users user = optionalUser.get();
            String displayName = user.getDisplayName();
        return displayName;}
        else {
            throw new RuntimeException("User with student ID " + userId + " not found");
        }  

        
    }

    public Users updateProfileImage(String userId, String profileImageUrl) throws Exception {
        try {
            Optional<Users> optionalExistingUser = usersRepository.findById(userId);
            if (optionalExistingUser.isPresent()) {
                Users existingUser = optionalExistingUser.get();
                if (existingUser != null) {
                    existingUser.setProfileImageUrl(profileImageUrl);
                    Users updatedUser = usersRepository.save(existingUser);

                    Query query1 = new Query(Criteria.where("userId").is(userId));
                    Update update1 = new Update().set("postedByImageUrl", profileImageUrl);
                    mongoTemplate.updateMulti(query1, update1, CommunityPost.class);

                    Query query2 = new Query(Criteria.where("userId").is(userId));
                    Update update2 = new Update().set("commentedByImageUrl", profileImageUrl);
                    mongoTemplate.updateMulti(query2, update2, Comment.class);

                    Query query3 = new Query(Criteria.where("repostedUserId").is(userId));
                    Update update3 = new Update().set("repostedUserImageUrl", profileImageUrl);
                    mongoTemplate.updateMulti(query3, update3, CommunityPost.class);
                    
                    return updatedUser;
            }
            } else {
                return null;
            }
        } catch (Exception e) {
            throw new Exception("An error occurred while updating profile image", e);
        }

        return null;
    }

}
