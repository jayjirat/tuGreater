package tuGreaterBackend.cn333.backend.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
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

    @PostMapping("")
    public ResponseEntity<?> postReport(@RequestBody Report report) {
        try {
            Report newReport = reportService.createReport(report);
            return ResponseEntity.status(HttpStatus.CREATED).body(newReport);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }

}