package com.example.demo.utils;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class WordEntity {
    private String word;
    private int beginPosition;
    private int endPosition;
    private int type;
    private int len;
}
