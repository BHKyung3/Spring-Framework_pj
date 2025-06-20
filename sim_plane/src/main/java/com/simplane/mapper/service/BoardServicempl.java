package com.simplane.mapper.service;

import com.simplane.mapper.domain.BoardVO;
import com.simplane.mapper.mapper.BoardMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor //생성자 주입
public class BoardServicempl implements BoardService {

    private final BoardMapper mapper;

    // 게시글 수정
    @Override
    public boolean modify(BoardVO board){
        log.info("modify..........");
        return mapper.update(board) == 1;
    }
}
