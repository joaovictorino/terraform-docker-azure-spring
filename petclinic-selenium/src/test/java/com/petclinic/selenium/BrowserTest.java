package com.petclinic.selenium;

import org.junit.jupiter.api.Test;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

public class BrowserTest {
    @Test
    public void shouldOpenBrowser() {
        ChromeOptions options = new ChromeOptions();
        options.setBinary("/mnt/c/'Program Files (x86)'/Google/Chrome/Application/chrome.exe");
        System.setProperty("webdriver.chrome.driver", "drivers/chromedriver");
        WebDriver browser = new ChromeDriver(options);
        browser.navigate().to("http://localhost:8080");
        browser.quit();
    }
}
