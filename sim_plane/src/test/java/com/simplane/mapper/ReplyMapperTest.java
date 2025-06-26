package com.simplane.mapper;

import com.simplane.domain.BoardVO;
import com.simplane.domain.ReplyVO;
import junit.framework.TestCase;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReplyMapperTest extends TestCase {

    @Autowired
    private ReplyMapper mapper;

    //댓글 조회 테스트
    @Test
    public void testRead() {
        log.info(mapper.read(1L));
    }

    //댓글 수정 테스트
    @Test
    public void testUpdate() {
        ReplyVO vo = ReplyVO.builder()
                .reply("다음 생에는 돌멩이로 태어난다 꼭")
                .replyid(1L)
                .build();
        log.info(mapper.update(vo));
    }
}