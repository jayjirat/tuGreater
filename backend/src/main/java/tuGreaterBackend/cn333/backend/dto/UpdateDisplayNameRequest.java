package tuGreaterBackend.cn333.backend.dto;
import jakarta.validation.constraints.NotBlank;

public class UpdateDisplayNameRequest {
    
    @NotBlank(message = "Display name cannot be blank")
    private String displayName;

    public String getDisplayName() {
        return displayName;
    }
    
    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }
}
