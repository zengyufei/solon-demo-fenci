//package com.example.demo.controller;
//
//import cn.hutool.core.date.DateUtil;
//import cn.hutool.core.util.NumberUtil;
//import cn.hutool.core.util.StrUtil;
//import com.example.demo.utils.KeywordUtil;
//import com.example.demo.utils.ResourceChangeNotifier;
//import com.example.demo.utils.WordEntity;
//import com.github.houbb.segment.support.segment.result.impl.SegmentResultHandlers;
//import com.github.houbb.segment.util.SegmentHelper;
//import org.apdplat.word.WordSegmenter;
//import org.apdplat.word.segmentation.Word;
//import org.noear.solon.annotation.Controller;
//import org.noear.solon.annotation.Mapping;
//import org.noear.solon.annotation.Post;
//
//import java.util.*;
//
//@Controller
//public class OldController {
//
//
//    private static Set<String> jiebaBiBang(String text) {
//        Set<String> result = new HashSet<>();
//        final List<String> words = SegmentHelper.segment(text, SegmentResultHandlers.word());
//        for (String word : words) {
//            if (word.length() <= 1) {
//                continue;
//            }
//            if (NumberUtil.isNumber(word)) {
//                continue;
//            }
//            try {
//                DateUtil.parse(word);
//                continue;
//            } catch (Exception ignored) {
//            }
//            result.add(word);
//        }
//        return result;
//    }
//
//    private static Set<String> keywoBiBang(String text) {
//        Set<String> result = new HashSet<>();
//        final List<WordEntity> words = KeywordUtil.extract(text);
//        for (WordEntity wordEntity : words) {
//            final String word = wordEntity.getWord();
//            if (word.length() <= 1) {
//                continue;
//            }
//            if (NumberUtil.isNumber(word)) {
//                continue;
//            }
//            try {
//                DateUtil.parse(word);
//                continue;
//            } catch (Exception ignored) {
//            }
//            result.add(word);
//        }
//        return result;
//    }
//
//    private static String handlerSortKeyword(String text, String keyword) {
//        final List<String> inputWords = StrUtil.splitTrim(keyword, "\n");
//        KeywordUtil.clearWords();
//        KeywordUtil.addWords(inputWords);
//        final List<WordEntity> sortKeywords = KeywordUtil.getSortKeywords(text);
//        StringBuilder sb = new StringBuilder();
//
//        for (int i = 1; i < sortKeywords.size(); i++) {
//            final WordEntity beforeWordEntity = sortKeywords.get(i - 1);
//            final WordEntity nextWordEntity = sortKeywords.get(i);
//
//            sb.append(text, beforeWordEntity.getEndPosition() + 1, nextWordEntity.getBeginPosition());
//            sb.append("\n");
//        }
//
//        return sb.toString();
//    }
//
//    private String handlerMap(String text, String keyword) {
//        KeywordUtil.clearWords();
//        final List<String> inputWords = StrUtil.splitTrim(keyword, "\n");
//        KeywordUtil.addWords(inputWords);
//        final Map<String, List<WordEntity>> keywords = KeywordUtil.getKeywords(text);
//        StringBuilder sb = new StringBuilder();
//
//        boolean isLast = false;
//        for (int i = 0; i < inputWords.size(); i++) {
//            final String inputWord = inputWords.get(i);
//            if (StrUtil.isBlank(inputWord)) {
//                continue;
//            }
//            final int lastIndex = i + 1;
//            final String nextInputWord = inputWords.get(lastIndex);
//            if (keywords.containsKey(inputWord)) {
//                final List<WordEntity> curValue = keywords.get(inputWord);
//                final WordEntity curWordEntity = curValue.get(0);
//                if (lastIndex == inputWords.size() - 1) {
//                    isLast = true;
//                }
//                if (keywords.containsKey(nextInputWord)) {
//                    final List<WordEntity> nextValue = keywords.get(nextInputWord);
//                    final WordEntity nextWordEntity = nextValue.get(0);
//
//                    sb.append(text.substring(curWordEntity.getEndPosition() + 1, nextWordEntity.getBeginPosition()));
//                    sb.append("\n");
//                    curValue.remove(0);
//
//                    if (isLast) {
//                        break;
//                    }
//                }
//            }
//        }
//        return sb.toString();
//    }
//}
