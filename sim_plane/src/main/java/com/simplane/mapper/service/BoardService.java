package com.simplane.mapper.service;

import com.simplane.mapper.domain.BoardVO;

public interface BoardService {

    // 게시글 수정
    public boolean modify(BoardVO board);

}
