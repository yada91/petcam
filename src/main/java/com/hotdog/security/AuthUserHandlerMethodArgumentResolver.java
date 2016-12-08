package com.hotdog.security;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebArgumentResolver;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import com.hotdog.petcam.vo.Users;

public class AuthUserHandlerMethodArgumentResolver implements HandlerMethodArgumentResolver {
	@Override
	public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer,
			NativeWebRequest webRequest, WebDataBinderFactory binderFactory) throws Exception {
		if (this.supportsParameter(parameter) == false) {
			return WebArgumentResolver.UNRESOLVED;
		}

		// @authuser가 붙어잇는 파라미터 타입 비교
		HttpServletRequest httpServletRequest = webRequest.getNativeRequest(HttpServletRequest.class);

		// 세션 받기
		HttpSession session = httpServletRequest.getSession();

		Users authUser = (Users) session.getAttribute("authUser");
		return authUser;
	}

	@Override
	public boolean supportsParameter(MethodParameter parameter) {
		return parameter.getParameterAnnotation(AuthUser.class) != null
				&& parameter.getParameterType().equals(Users.class);
	}
}
