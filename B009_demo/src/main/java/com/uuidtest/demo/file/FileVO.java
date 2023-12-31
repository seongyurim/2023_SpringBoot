package com.uuidtest.demo.file;

import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Data;

@Data
public class FileVO {
    private String fileCode;
    private String filePath;
    private String storedName;
    private String originName;

    @JsonIgnore
    private MultipartFile multiFile;    
}
