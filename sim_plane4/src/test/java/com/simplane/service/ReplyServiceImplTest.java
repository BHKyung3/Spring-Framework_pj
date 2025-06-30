package com.simplane.service;

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
public class ReplyServiceImplTest extends TestCase {

    @Autowired
    private ReplyService replyService;

    @Test
    public void testGet() {
        log.info(String.valueOf(replyService.get(1L)));
    }

    @Test
    public void testModify() {
        ReplyVO vo = replyService.get(1L);
        vo.setReply("이제 컨트롤러만 남았어");
        log.info("Modify Result: " + replyService.modify(vo));
    }

}