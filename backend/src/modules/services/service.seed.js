const sampleServices = [
  {
    slug: "grooming",
    title: "Grooming",
    description: "Tắm, sấy, cắt tỉa và vệ sinh cơ bản cho thú cưng",
    detail:
      "Gói grooming giúp thú cưng sạch sẽ, thơm hơn và thoải mái hơn sau mỗi lần chăm sóc. Quy trình phù hợp cho cả chó và mèo có nhu cầu vệ sinh, chải lông, cắt móng và khử mùi nhẹ.",
    priceText: "Từ 150.000đ",
    category: "all",
    badge: "FEATURED",
    image:
      "https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?auto=format&fit=crop&w=900&q=80",
    isFeatured: true,
    icon: "scissors",
    ratingText: "4.8 (1.2k)",
    reviewText: "1.2k lượt đặt",
    usageText: "1.2k lượt đặt",
    durationText: "60 phút",
    promo: {
      title: "Ưu đãi độc quyền",
      description: "Giảm 20% cho lần đặt Grooming đầu tiên",
      discountText: "-20%",
      tone: "orange",
    },
    includedItems: [
      "Tắm bằng sữa tắm chuyên dụng",
      "Sấy khô và chải lông",
      "Cắt tỉa lông cơ bản",
      "Vệ sinh tai, mắt",
      "Cắt móng an toàn",
      "Xịt thơm nhẹ sau khi hoàn tất",
    ],
    benefits: [
      "Giúp thú cưng sạch sẽ và thơm hơn",
      "Lông mềm mượt, hạn chế rối lông",
      "Hạn chế vi khuẩn và mùi hôi trên da",
      "Giúp bé cưng thoải mái, dễ chịu hơn",
      "Tăng tính thẩm mỹ cho thú cưng",
    ],
    noticeText: "Nên đặt lịch trước ít nhất 2 tiếng để trung tâm chuẩn bị tốt nhất.",
    sortOrder: 1,
  },
  {
    slug: "pet-hotel",
    title: "Pet Hotel",
    description: "Khách sạn thú cưng an toàn, sạch sẽ khi bạn đi xa",
    detail:
      "Pet Hotel cung cấp không gian lưu trú riêng tư, sạch sẽ và được chăm sóc theo lịch. Phù hợp khi chủ nuôi bận công tác, du lịch hoặc cần gửi bé trong ngày.",
    priceText: "Từ 250.000đ",
    category: "all",
    badge: "HOTEL",
    image:
      "https://images.unsplash.com/photo-1560743641-3914f2c45636?auto=format&fit=crop&w=900&q=80",
    isFeatured: true,
    icon: "hotel",
    ratingText: "4.9 (896)",
    reviewText: "896 lượt đặt",
    usageText: "896 lượt đặt",
    durationText: "Theo ngày",
    promo: {
      title: "Ưu đãi đặc biệt",
      description: "Giảm 15% khi đặt từ 2 ngày trở lên",
      discountText: "-15%",
      tone: "orange",
    },
    includedItems: [
      "Không gian lưu trú riêng cho thú cưng",
      "Cho ăn theo lịch của chủ",
      "Thay nước sạch mỗi ngày",
      "Dọn vệ sinh khu vực ở",
      "Theo dõi tình trạng sức khỏe cơ bản",
      "Cập nhật hình ảnh thú cưng cho chủ",
    ],
    benefits: [
      "An toàn, sạch sẽ, thoải mái như ở nhà",
      "Được chăm sóc và chơi đùa mỗi ngày",
      "Chủ nhận ảnh/video cập nhật mỗi ngày",
      "Giảm stress khi có người chăm sóc",
      "Có không gian riêng để nghỉ ngơi",
    ],
    noticeText: "Nên đặt trước ít nhất 6 tiếng để chúng tôi chuẩn bị phòng cho bé.",
    sortOrder: 2,
  },
  {
    slug: "veterinarian",
    title: "Bác sĩ thú y",
    description: "Khám sức khỏe, tư vấn điều trị và theo dõi tình trạng thú cưng",
    detail:
      "Dịch vụ bác sĩ thú y giúp kiểm tra sức khỏe tổng quát, tư vấn dinh dưỡng, điều trị cơ bản và đề xuất lịch tiêm phòng/tái khám phù hợp cho từng bé.",
    priceText: "Từ 200.000đ",
    category: "all",
    badge: "HEALTH",
    image:
      "https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?auto=format&fit=crop&w=900&q=80",
    isFeatured: true,
    icon: "medical",
    ratingText: "4.9 (1.5k)",
    reviewText: "1.5k lượt đặt",
    usageText: "1.5k lượt đặt",
    durationText: "30 phút",
    promo: {
      title: "Ưu đãi cho khách mới",
      description: "Miễn phí tư vấn nhanh 10 phút qua chat hoặc gọi",
      discountText: "0đ",
      tone: "green",
    },
    includedItems: [
      "Khám sức khỏe tổng quát",
      "Kiểm tra da, lông, mắt, tai",
      "Tư vấn tình trạng ăn uống",
      "Tư vấn điều trị cơ bản",
      "Đề xuất lịch tiêm phòng/tái khám",
      "Lưu hồ sơ sức khỏe thú cưng",
    ],
    benefits: [
      "Phát hiện sớm vấn đề sức khỏe",
      "Điều trị và chăm sóc kịp thời",
      "Cách chăm sóc và dinh dưỡng phù hợp",
      "Theo dõi hồ sơ sức khỏe dễ dàng",
      "Giảm rủi ro bệnh nặng do phát hiện trễ",
    ],
    noticeText:
      "Nếu bé có dấu hiệu bất thường, vui lòng đặt lịch sớm để được hỗ trợ kịp thời.",
    sortOrder: 3,
  },
  {
    title: "Cắt tỉa & Vệ sinh chó",
    description:
      "Tắm gội, vệ sinh tai, cắt móng, chải lông và khử mùi cho chó.",
    detail:
      "Phù hợp với chó nhỏ, chó vừa và chó lớn. Có thể chọn gói tắm thường, tắm khử mùi hoặc tắm trị ve rận.",
    priceText: "Từ 250.000đ",
    category: "dog",
    badge: "POPULAR",
    image:
      "https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?auto=format&fit=crop&w=900&q=80",
    sortOrder: 10,
  },
  {
    title: "Spa & Thư giãn cho chó",
    description:
      "Massage thư giãn, dưỡng lông và chăm sóc da cho chó sau thời gian vận động.",
    detail:
      "Dành cho chó bị rụng lông, khô da, mệt mỏi hoặc cần chăm sóc ngoại hình.",
    priceText: "Từ 350.000đ",
    category: "dog",
    badge: "SPA",
    image:
      "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?auto=format&fit=crop&w=900&q=80",
    sortOrder: 20,
  },
  {
    title: "Khách sạn chó",
    description:
      "Nơi lưu trú an toàn khi chủ bận, đi công tác hoặc du lịch.",
    detail:
      "Có khu vực nghỉ riêng, cho ăn theo lịch, vệ sinh hằng ngày và cập nhật hình ảnh cho chủ nuôi.",
    priceText: "Từ 400.000đ / ngày",
    category: "dog",
    badge: "HOTEL",
    image:
      "https://images.unsplash.com/photo-1560743641-3914f2c45636?auto=format&fit=crop&w=900&q=80",
    sortOrder: 30,
  },
  {
    title: "Chăm sóc Y tế cho chó",
    description:
      "Khám sức khỏe, tư vấn dinh dưỡng, tiêm phòng và kiểm tra định kỳ.",
    detail:
      "Phù hợp với chó con, chó trưởng thành hoặc chó lớn tuổi cần theo dõi sức khỏe thường xuyên.",
    priceText: "Từ 500.000đ",
    category: "dog",
    badge: "HEALTH",
    image:
      "https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?auto=format&fit=crop&w=900&q=80",
    sortOrder: 40,
  },
  {
    title: "Tắm & Vệ sinh mèo",
    description:
      "Tắm nhẹ nhàng, vệ sinh tai, cắt móng và làm sạch lông cho mèo.",
    detail:
      "Phù hợp với mèo lông ngắn, mèo lông dài hoặc mèo ít được tắm. Quy trình nhẹ nhàng để giảm căng thẳng.",
    priceText: "Từ 220.000đ",
    category: "cat",
    badge: "CARE",
    image:
      "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?auto=format&fit=crop&w=900&q=80",
    sortOrder: 50,
  },
  {
    title: "Chải lông & Gỡ rối",
    description:
      "Chăm sóc lông, gỡ rối, giảm rụng lông và làm sạch lớp lông chết.",
    detail:
      "Đặc biệt phù hợp với mèo Anh lông dài, Ba Tư, Ragdoll hoặc các bé mèo hay rụng lông.",
    priceText: "Từ 280.000đ",
    category: "cat",
    badge: "GROOMING",
    image:
      "https://images.unsplash.com/photo-1573865526739-10659fec78a5?auto=format&fit=crop&w=900&q=80",
    sortOrder: 60,
  },
  {
    title: "Spa thư giãn cho mèo",
    description: "Massage nhẹ, dưỡng lông và chăm sóc da dành riêng cho mèo.",
    detail:
      "Giúp mèo thư giãn, giảm căng thẳng, lông mềm hơn và hạn chế mùi khó chịu.",
    priceText: "Từ 320.000đ",
    category: "cat",
    badge: "SPA",
    image:
      "https://images.unsplash.com/photo-1543852786-1cf6624b9987?auto=format&fit=crop&w=900&q=80",
    sortOrder: 70,
  },
  {
    title: "Khách sạn mèo",
    description: "Không gian lưu trú riêng tư, yên tĩnh và sạch sẽ cho mèo.",
    detail:
      "Mỗi bé có khu vực nghỉ riêng, được cho ăn đúng giờ, vệ sinh cát và cập nhật tình trạng hằng ngày.",
    priceText: "Từ 350.000đ / ngày",
    category: "cat",
    badge: "HOTEL",
    image:
      "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=900&q=80",
    sortOrder: 80,
  },
];

module.exports = {
  sampleServices,
};
