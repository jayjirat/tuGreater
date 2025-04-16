package tuGreaterBackend.cn333.backend.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import tuGreaterBackend.cn333.backend.entity.Report;
import tuGreaterBackend.cn333.backend.repository.ReportRepository;

@Service
public class ReportService {

    @Autowired
    private final ReportRepository reportRepository;

    public ReportService(ReportRepository reportRepository) {
        this.reportRepository = reportRepository;
    }

    public Report createReport(Report report) {
        try {
            return reportRepository.save(report);
        } catch (Exception e) {
            throw new RuntimeException("Failed to create new post", e);
        }
    }
}

