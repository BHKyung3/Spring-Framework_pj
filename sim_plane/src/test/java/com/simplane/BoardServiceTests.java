package com.simplane;

import com.simplane.domain.BoardVO;
import com.simplane.service.BoardService;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardServiceTests {

    @Autowired
    private BoardService boardService;

    @Test
    public void updateServiceTest(){
        BoardVO vo = BoardVO.builder()
                .boardid(1L)
                .title("서비스에서 수정한 제목")
                .content("서비스 수정 테스트 내용")
                .imagePath("images/service_test.jpg")
                .build();

        boolean result = boardService.modify(vo);
        log.info("서비스 수정 결과: " + result);
    }

}
