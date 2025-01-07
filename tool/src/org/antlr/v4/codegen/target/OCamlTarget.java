package org.antlr.v4.codegen.target;

import org.antlr.v4.codegen.Target;
import org.antlr.v4.tool.Grammar;
import org.antlr.v4.codegen.CodeGenerator;
import org.antlr.v4.codegen.Target;
import org.stringtemplate.v4.STGroup;

import java.util.*;

public class OCamlTarget extends Target {
	public OCamlTarget(CodeGenerator gen) {
		super(gen);
	}

	protected static final HashSet<String> reservedWords = new HashSet<>(Arrays.asList(
		"let", "in", "fun", "if", "then", "else", "match", "with", "type",
		"module", "open"
	));

	protected static final Map<Character, String> targetCharValueEscape;
	static {
		// https://ocaml.org/manual/5.2/lex.html
		HashMap<Character, String> map = new HashMap<>();
		addEscapedChar(map, '\\');
		addEscapedChar(map, '\"');
		addEscapedChar(map, '\'');
		addEscapedChar(map, '\n', 'n');
		addEscapedChar(map, '\r', 'r');
		addEscapedChar(map, '\t', 't');
		addEscapedChar(map, '\b', 'b');
		targetCharValueEscape = map;
	}

	@Override
	protected Set<String> getReservedWords() {
		return reservedWords;
	}

	@Override
	public Map<Character, String> getTargetCharValueEscape() {
		return targetCharValueEscape;
	}

	@Override
	protected String escapeChar(int v) {
		return String.format("\\UChar.of_int %X", v);
	}
}
