package com.example.demo.controller;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.NumberUtil;
import cn.hutool.core.util.StrUtil;
import com.example.demo.utils.WordEntity;
import org.apdplat.word.WordSegmenter;
import org.apdplat.word.dictionary.DictionaryFactory;
import org.apdplat.word.segmentation.Word;
import org.noear.solon.annotation.Controller;
import org.noear.solon.annotation.Mapping;
import org.noear.solon.annotation.Post;

import java.util.*;

@Controller
public class KeyWordController {


    @Post
    @Mapping("/word/find")
    public String find(String text, String keyword, String showLabel, String symbol, String endSymbol) {
        showLabel = StrUtil.blankToDefault(showLabel, "1");
        final List<String> inputWords = StrUtil.splitTrim(keyword, "\n");
        // 利用split好的inputWords集合，去消费text；
        final List<WordEntity> resultList = new ArrayList<>();
        for (String inputWord : inputWords) {

            if (StrUtil.isNotBlank(symbol)) {
                inputWord = inputWord + symbol;
            }
            // 先遍历inputWords，第一个inputWord消费text，匹配text是否存在是否包含，如果存在可能多个，则只需要取第一个
            // 第二次遍历inputWords，第二个inputWord消费text，匹配text是否存在是否包含，如果存在可能多个，则只需要取第一个；第一个inputWord的endIndex作为开始，第二个inputWord的beginIndex作为结束，截取中间的内容并放到List<String>
            final int beginIndex = text.indexOf(inputWord);
            if (beginIndex > -1) {
                final int wordLen = inputWord.length();
                final int endIndex = beginIndex + wordLen;
                final WordEntity wordEntity = new WordEntity();
                wordEntity.setKey(inputWord);
                wordEntity.setBeginPosition(beginIndex);
                wordEntity.setEndPosition(endIndex);
                wordEntity.setType(-1);
                wordEntity.setLen(wordLen);
                resultList.add(wordEntity);
            }
        }

        checkIndex(text, resultList);

        final StringBuilder sb = new StringBuilder();

        final List<WordEntity> sortWordEntities = resultList.stream()
                .sorted(Comparator.comparingInt(WordEntity::getBeginPosition))
                .toList();
        WordEntity beforeWordEntity = null;
        final int maxLen = sortWordEntities.size();
        for (int i = 0; i < maxLen; i++) {
            final WordEntity nextWordEntity = sortWordEntities.get(i);


            try {
                if (beforeWordEntity == null) {
                    continue;
                }
                final String value = text.substring(beforeWordEntity.getEndPosition(), nextWordEntity.getBeginPosition());
                final String trim = StrUtil.trim(value);
                final String word = StrUtil.removeSuffix(trim, endSymbol);
                beforeWordEntity.setWord(word);

                if (StrUtil.equals(showLabel, "1")) {
                    sb.append(beforeWordEntity.getKey());
                }
                sb.append(word);
                sb.append("\n");

            } finally {
                beforeWordEntity = nextWordEntity;
                if (i == maxLen - 1) {
                    // end element
                    final String value = text.substring(beforeWordEntity.getEndPosition());
                    final String trim = StrUtil.trim(value);
                    final String word = StrUtil.removeSuffix(trim, endSymbol);
                    beforeWordEntity.setWord(word);

                    if (StrUtil.equals(showLabel, "1")) {
                        sb.append(beforeWordEntity.getKey());
                    }
                    sb.append(word);
                    sb.append("\n");
                }
            }

        }

        return sb.toString();
    }


    @Post
    @Mapping("/word/biBang")
    public Set<String> biBang(String text) {
        List<Word> words = WordSegmenter.segWithStopWords(text);
        Set<String> result = new HashSet<>();
        for (Word word : words) {
            final String wordText = word.getText();
            if (wordText.length() <= 1) {
                continue;
            }
            if (NumberUtil.isNumber(wordText)) {
                continue;
            }
            try {
                DateUtil.parse(wordText);
                continue;
            } catch (Exception ignored) {
            }
            result.add(wordText);
        }
        return result;
    }


    @Post
    @Mapping("/word/add")
    public String add(String type, String word) {
        DictionaryFactory.getDictionary(type).add(word);
//        ResourceChangeNotifier.addDic(word);
        return "add success";
    }

    @Post
    @Mapping("/word/remove")
    public String remove(String type, String word) {
        DictionaryFactory.getDictionary(type).remove(word);
//        ResourceChangeNotifier.removeDic(word);
        return "remove success";
    }


//    @Get
//    @Mapping("/word/reload")
//    public String dicReload() {
//		DictionaryFactory.reload();//更改词典路径之后，重新加载词典
//        return "reload success";
//    }


    private static void checkIndex(String text, List<WordEntity> resultList) {
        List<WordEntity> resetList = checkIndex(resultList);

        if (CollUtil.isNotEmpty(resetList)) {
            for (WordEntity wordEntity : resetList) {
                final String key = wordEntity.getKey();
                final int endPosition = wordEntity.getEndPosition();
                final int beginIndex = text.indexOf(key, endPosition);
                if (beginIndex > -1) {
                    final int wordLen = key.length();
                    final int endIndex = beginIndex + wordLen;
                    wordEntity.setBeginPosition(beginIndex);
                    wordEntity.setEndPosition(endIndex);
                }
            }
            checkIndex(text, resultList);
        }
    }

    private static List<WordEntity> checkIndex(List<WordEntity> resultList) {
        List<WordEntity> resetList = new ArrayList<>();
        for (WordEntity wordEntity : resultList) {
            final int beginPosition = wordEntity.getBeginPosition();
            final int endPosition = wordEntity.getEndPosition();

            for (WordEntity wwordEntity : resultList) {
                if (wordEntity == wwordEntity) {
                    continue;
                }
                final int bbeginPosition = wwordEntity.getBeginPosition();
                final int bendPosition = wwordEntity.getEndPosition();
                if (beginPosition > bbeginPosition && endPosition <= bendPosition) {
                    resetList.add(wordEntity);
                }
            }
        }
        return resetList;
    }
}
