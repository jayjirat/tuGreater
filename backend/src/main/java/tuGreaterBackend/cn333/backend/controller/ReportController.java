package tuGreaterBackend.cn333.backend.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import tuGreaterBackend.cn333.backend.entity.Report;
import tuGreaterBackend.cn333.backend.service.ReportService;

@RestController
@RequestMapping("/report")
public class ReportController {
    private final ReportService reportService;

    public ReportController(ReportService reportService) {
        this.reportService = reportService;
    }

    @GetMapping("")
    public ResponseEntity<?> getReport() {
        try {
            List<Report> reportPost = reportService.getReport();
            return ResponseEntity.ok(reportPost);
        }catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }
}