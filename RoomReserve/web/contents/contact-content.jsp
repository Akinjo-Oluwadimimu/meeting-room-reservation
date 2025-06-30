<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="../components/navigation.jsp" />
<jsp:include page="../components/hero.jsp">
    <jsp:param name="variant" value="centered" />
    <jsp:param name="center" value="centered" />
    <jsp:param name="title" value="Contact Us" />
    <jsp:param name="subtitle" value="Have questions or need support? Our team is here to help you with your meeting room reservation needs." />
</jsp:include>

<!-- Contact Content -->
<section class="py-16 bg-white">
    <div class="container mx-auto px-4">
        <div class="flex flex-col lg:flex-row gap-12">
            <!-- Contact Form -->
            <div class="lg:w-1/2" id="contact-form">
                <h2 class="text-2xl font-bold mb-6 text-gray-800">Send Us a Message</h2>
                <form class="space-y-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="first-name" class="block text-sm font-medium text-gray-700 mb-1">First Name*</label>
                            <input type="text" id="first-name" name="first-name" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                                   placeholder="Your first name" required>
                        </div>
                        <div>
                            <label for="last-name" class="block text-sm font-medium text-gray-700 mb-1">Last Name*</label>
                            <input type="text" id="last-name" name="last-name" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                                   placeholder="Your last name" required>
                        </div>
                    </div>

                    <div>
                        <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email Address*</label>
                        <input type="email" id="email" name="email" 
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                               placeholder="your@email.com" required>
                    </div>

<!--                        <div>
                        <label for="institution" class="block text-sm font-medium text-gray-700 mb-1">Institution</label>
                        <input type="text" id="institution" name="institution" 
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                               placeholder="Your university or college">
                    </div>-->

                    <div>
                        <label for="subject" class="block text-sm font-medium text-gray-700 mb-1">Subject*</label>
                        <select id="subject" name="subject" 
                                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" required>
                            <option value="">Select a subject</option>
                            <option value="general">General Inquiry</option>
                            <option value="support">Technical Support</option>
                            <option value="sales">Sales Questions</option>
                            <option value="feedback">Product Feedback</option>
                            <option value="other">Other</option>
                        </select>
                    </div>

                    <div>
                        <label for="message" class="block text-sm font-medium text-gray-700 mb-1">Message*</label>
                        <textarea id="message" name="message" rows="3" 
                                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                                  placeholder="Your message..." required></textarea>
                    </div>

                    <div class="flex items-start">
                        <div class="flex items-center h-5">
                            <input id="consent" name="consent" type="checkbox" 
                                   class="focus:ring-blue-500 h-4 w-4 text-blue-600 border-gray-300 rounded" required>
                        </div>
                        <div class="ml-3 text-sm">
                            <label for="consent" class="font-medium text-gray-700">I agree to the <a href="#" class="text-blue-600 hover:text-blue-500">Privacy Policy</a> and consent to my data being processed.</label>
                        </div>
                    </div>

                    <div>
                        <button type="submit" 
                                class="w-full flex justify-center py-3 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                            Send Message
                        </button>
                    </div>
                </form>
            </div>

            <!-- Contact Information -->
            <div class="lg:w-1/2">
                <div class="bg-gray-50 p-8 rounded-lg shadow-sm">
                    <h2 class="text-2xl font-bold mb-6 text-gray-800">Contact Information</h2>

                    <div class="space-y-6">
                        <div class="flex items-start">
                            <div class="flex-shrink-0 bg-blue-100 p-3 rounded-lg text-blue-600">
                                <i class="fas fa-map-marker-alt text-xl"></i>
                            </div>
                            <div class="ml-4">
                                <h3 class="text-lg font-medium text-gray-800">Our Office</h3>
                                <p class="mt-1 text-gray-600">123 Academic Way<br>University Campus<br>City, State 12345</p>
                            </div>
                        </div>

                        <div class="flex items-start">
                            <div class="flex-shrink-0 bg-blue-100 p-3 rounded-lg text-blue-600">
                                <i class="fas fa-phone-alt text-xl"></i>
                            </div>
                            <div class="ml-4">
                                <h3 class="text-lg font-medium text-gray-800">Phone</h3>
                                <p class="mt-1 text-gray-600">
                                    <a href="tel:+15551234567" class="hover:text-blue-600">(555) 123-4567</a><br>
                                    Monday-Friday, 9am-5pm EST
                                </p>
                            </div>
                        </div>

                        <div class="flex items-start">
                            <div class="flex-shrink-0 bg-blue-100 p-3 rounded-lg text-blue-600">
                                <i class="fas fa-envelope text-xl"></i>
                            </div>
                            <div class="ml-4">
                                <h3 class="text-lg font-medium text-gray-800">Email</h3>
                                <p class="mt-1 text-gray-600">
                                    <a href="mailto:support@roomreserve.edu" class="hover:text-blue-600">support@roomreserve.edu</a><br>
                                    <a href="mailto:sales@roomreserve.edu" class="hover:text-blue-600">sales@roomreserve.edu</a>
                                </p>
                            </div>
                        </div>

                        <div class="flex items-start">
                            <div class="flex-shrink-0 bg-blue-100 p-3 rounded-lg text-blue-600">
                                <i class="fas fa-clock text-xl"></i>
                            </div>
                            <div class="ml-4">
                                <h3 class="text-lg font-medium text-gray-800">Support Hours</h3>
                                <p class="mt-1 text-gray-600">
                                    Monday-Friday: 8:00 AM - 6:00 PM<br>
                                    Saturday: 10:00 AM - 2:00 PM<br>
                                    Sunday: Closed
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    // FAQ toggle functionality
    document.querySelectorAll('.bg-white button').forEach(button => {
        button.addEventListener('click', function() {
            const answer = this.nextElementSibling;
            const icon = this.querySelector('i');

            if (answer.classList.contains('hidden')) {
                answer.classList.remove('hidden');
                icon.classList.replace('fa-chevron-down', 'fa-chevron-up');
            } else {
                answer.classList.add('hidden');
                icon.classList.replace('fa-chevron-up', 'fa-chevron-down');
            }
        });
    });

    // Form validation would be added here in a real implementation
    document.querySelector('form').addEventListener('submit', function(e) {
        e.preventDefault();
        // Add your contact form submission logic here
        console.log('Contact form submitted');
        Swal.fire(
            'Sent!',
            'Thank you for your message! We will respond shortly.',
            'success'
        );
        this.reset();
    });
</script>
<c:choose>
    <c:when test="${param.minimalFooter != null || fn:endsWith(pageContext.request.requestURI, 'login.jsp') || fn:endsWith(pageContext.request.requestURI, 'register.jsp')}">
        <jsp:include page="components/footer-minimal.jsp" />
    </c:when>
    <c:otherwise>
        <jsp:include page="../components/footer.jsp" />
    </c:otherwise>
</c:choose>