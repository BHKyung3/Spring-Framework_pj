package com.simplane.mapper;

import com.simplane.domain.BoardVO;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardMapperTests {

    @Autowired
    private BoardMapper mapper;

    @Test
    public void testUpdate() {
        BoardVO vo = BoardVO.builder()
                .boardid(1L)
                .title("싸다구 심리테스트")
                .content("한 번에 테스트 성공 기원")
                .imagePath("images/sample1.jpg")
                .build();

        int result = mapper.update(vo);
        log.info("업데이트 결과: " + result);
    }
}
