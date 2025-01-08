package org.antlr.v4.codegen.test;

import org.stringtemplate.v4.STGroup;
import java.net.URL;
import static org.junit.Assert.*;
import org.junit.Test;
import org.stringtemplate.v4.STGroupFile;

public class OCamlSTGTest {
	private STGroup loadTemplate(String templatePath) {
		ClassLoader classLoader = getClass().getClassLoader();
		URL templates = classLoader.getResource(templatePath);
		assert templates != null;
		return new STGroupFile(templates, "UTF-8", '<', '>');
	}
	@Test
	public void testTemplateRendering() {
		STGroup targetTemplates = loadTemplate("org/antlr/v4/tool/templates/codegen/OCaml/OCaml.stg");

		String rendered = targetTemplates.getInstanceOf("fileHeader")
			.add("grammarFileName", "test")
			.add("ANTLRVersion", "4.13.2")
			.render();
		assertEquals(" (* Generated from test by ANTLR 4.13.2 *)\n" +
			" ", rendered);
	}

	@Test
	public void testVisitorFileRendering() {
		STGroup targetTemplates = loadTemplate("org/antlr/v4/tool/templates/codegen/OCaml/OCaml.stg");

		String rendered = targetTemplates.getInstanceOf("VisitorFile")
			.add("file", "TestFile")
			.add("header", "TestHeader")
			.add("namedActions", "TestActions")
			.render();

		assertEquals(
			"  (* Generated from  by ANTLR  *)\n" +
				"  \n" +
				" open Antlr_runtime\n" +
				"\n" +
				" (* This class defines a complete generic visitor for a parse tree produced by . *)\n" +
				"\n" +
				" module Visitor = struct\n" +
				"\n" +
				"   (* Define type for the visitor *)\n" +
				"   type 'a t = {\n" +
				"   }\n" +
				"\n" +
				"   (* Default implementation that visits children *)\n" +
				"   let default_visitor = {\n" +
				"   }\n" +
				"\n" +
				"   (* Function to visit children of a node *)\n" +
				"   and visit_children ctx =\n" +
				"     (* Generic implementation to iterate over children *)\n" +
				"     List.fold_left (fun acc child -> child |> visit ctx) () (children ctx)\n" +
				"\n" +
				" end;;\n" +
				" ",
			rendered
		);
	}

	@Test
	public void testListenerFileRendering() {
		STGroup targetTemplates = loadTemplate("org/antlr/v4/tool/templates/codegen/OCaml/OCaml.stg");

		String rendered = targetTemplates.getInstanceOf("ListenerFile")
			.add("file", "TestFile")
			.add("header", "TestHeader")
			.add("namedActions", "TestActions")
			.render();

		assertEquals(
			"  (* Generated from  by ANTLR  *)\n" +
				"  \n" +
				" open Antlr_runtime.Input_stream\n" +
				" open Antlr_runtime.Atn_deserialize\n" +
				" open Antlr_runtime.Parser\n" +
				" open Antlr_runtime.Token\n" +
				" open Antlr_runtime.Lexer\n" +
				" open Antlr_runtime.Lexer_atn_simulator\n" +
				"\n" +
				" TestHeader\n" +
				"\n" +
				"  (* This module defines a complete listener for a parse tree produced by . *)\n" +
				"  module Listener = struct\n" +
				"\n" +
				"  (* Define type for the listener *)\n" +
				"  type t = {\n" +
				"  }\n" +
				"\n" +
				"  let default_listener = {\n" +
				"  }\n" +
				"\n" +
				"  end;;\n" +
				" ",
			rendered
		);
	}

	public static void main(String[] args) {
		OCamlSTGTest test = new OCamlSTGTest();
		try {
			test.testTemplateRendering();
			test.testVisitorFileRendering();
			test.testListenerFileRendering();
			System.out.println("Test passed!");
		} catch (AssertionError e) {
			System.err.println("Test failed: " + e.getMessage());
		}
	}
}
